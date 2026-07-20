# Soluzioni — versione Terraform

I fix si applicano **modificando `main.tf`** e rilanciando `make apply` (o `terraform apply`). Il file `audit.sh` è identico alla versione imperativa: dopo l'apply deve risultare `PASS` su tutti e tre i controlli.

Ogni sezione mostra il blocco *da* / *a* in formato diff, seguito dal comando per applicare.

## 1. IAM — privilegi eccessivi

Il problema: `aws_iam_user_policy.mario_rossi_full_access` concede `Action:*` su `Resource:*`.

Fix — sostituire l'intera policy inline con una a minimo privilegio (sola lettura sul bucket che serve). Rinominare anche la risorsa così Terraform la ricrea con il nome giusto:

```diff
-resource "aws_iam_user_policy" "mario_rossi_full_access" {
-  name = "full-access"
-  user = aws_iam_user.mario_rossi.name
-
-  policy = jsonencode({
-    Version = "2012-10-17"
-    Statement = [{
-      Effect   = "Allow"
-      Action   = "*"
-      Resource = "*"
-    }]
-  })
-}
+resource "aws_iam_user_policy" "mario_rossi_s3_readonly" {
+  name = "s3-readonly"
+  user = aws_iam_user.mario_rossi.name
+
+  policy = jsonencode({
+    Version = "2012-10-17"
+    Statement = [{
+      Effect = "Allow"
+      Action = ["s3:GetObject", "s3:ListBucket"]
+      Resource = [
+        aws_s3_bucket.nuvolasoft.arn,
+        "${aws_s3_bucket.nuvolasoft.arn}/*",
+      ]
+    }]
+  })
+}
```

## 2. S3 — bucket pubblico

Il problema: Public Access Block interamente disattivato + bucket policy che consente `s3:GetObject` a `Principal: *`.

Fix — attivare tutti e quattro i flag del PAB **e** rimuovere del tutto la bucket policy pubblica:

```diff
 resource "aws_s3_bucket_public_access_block" "nuvolasoft" {
   bucket = aws_s3_bucket.nuvolasoft.id

-  block_public_acls       = false
-  ignore_public_acls      = false
-  block_public_policy     = false
-  restrict_public_buckets = false
+  block_public_acls       = true
+  ignore_public_acls      = true
+  block_public_policy     = true
+  restrict_public_buckets = true
 }

-resource "aws_s3_bucket_policy" "nuvolasoft_public_read" {
-  bucket = aws_s3_bucket.nuvolasoft.id
-
-  depends_on = [aws_s3_bucket_public_access_block.nuvolasoft]
-
-  policy = jsonencode({
-    Version = "2012-10-17"
-    Statement = [{
-      Effect    = "Allow"
-      Principal = "*"
-      Action    = "s3:GetObject"
-      Resource  = "${aws_s3_bucket.nuvolasoft.arn}/*"
-    }]
-  })
-}
```

## 3. SSM — segreto in chiaro

Il problema: `aws_ssm_parameter.db_password` è di tipo `String` (testo in chiaro) invece che `SecureString` (cifrato via KMS).

Fix — cambiare `type`:

```diff
 resource "aws_ssm_parameter" "db_password" {
   name  = var.ssm_param_name
-  type  = "String"
+  type  = "SecureString"
   value = var.ssm_param_value
 }
```

## Applicare e verificare

```bash
make apply     # terraform apply con le modifiche
make audit     # deve dare PASS su tutti e tre i controlli
```

Se `make apply` si lamenta di dipendenze o ordine di distruzione (tipico quando si toglie la bucket policy mentre si stringe il PAB nello stesso apply), Terraform gestisce il grafo da solo grazie al `depends_on` originale: lancia due volte se necessario, oppure prima `terraform apply -target=aws_s3_bucket_policy.nuvolasoft_public_read -destroy` e poi il resto.

## Perché farlo con Terraform (nota didattica)

La versione imperativa (`setup.sh` + fix con AWS CLI) risolve *questa istanza* del problema. La versione IaC risolve il problema *strutturalmente*:

- il `main.tf` è l'unica fonte di verità: se qualcuno reintroduce la policy `*:*`, il diff lo mostra subito;
- `terraform plan` è un audit preventivo — si integra con `tfsec` / `checkov` per fare shift-left dei controlli ISO 27001;
- `terraform destroy` garantisce reset pulito, evitando che risorse dimenticate lascino esposizioni.
