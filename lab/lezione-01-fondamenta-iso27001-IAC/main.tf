# Ambiente NuvolaSoft — versione Infrastructure as Code (Terraform).
# Replica esattamente lo stato prodotto da setup.sh: tre misconfig da correggere.
# I fix si applicano modificando questo file — vedi SOLUTIONS.md.

# ---------------------------------------------------------------------------
# 1) IAM — utente con policy inline troppo permissiva (Action:* Resource:*)
#    Controllo ISO 27001 violato: A.8.2 Minimo privilegio
# ---------------------------------------------------------------------------

resource "aws_iam_user" "mario_rossi" {
  name = var.iam_user_name
}

resource "aws_iam_user_policy" "mario_rossi_full_access" {
  name = "full-access"
  user = aws_iam_user.mario_rossi.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}

# ---------------------------------------------------------------------------
# 2) S3 — bucket con Public Access Block disattivato e bucket policy pubblica
#    Controllo ISO violato: sicurezza dei servizi cloud, controllo accessi
# ---------------------------------------------------------------------------

resource "aws_s3_bucket" "nuvolasoft" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "nuvolasoft" {
  bucket = aws_s3_bucket.nuvolasoft.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "nuvolasoft_public_read" {
  bucket = aws_s3_bucket.nuvolasoft.id

  # Richiede che il PAB non blocchi le policy pubbliche — quindi dipende dalla
  # risorsa sopra così che apply/destroy avvengano nell'ordine giusto.
  depends_on = [aws_s3_bucket_public_access_block.nuvolasoft]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.nuvolasoft.arn}/*"
    }]
  })
}

# File di dati clienti caricato nel bucket (equivalente di 'aws s3 cp' in setup.sh)
resource "aws_s3_object" "clienti_csv" {
  bucket       = aws_s3_bucket.nuvolasoft.id
  key          = "clienti.csv"
  content      = "nome,email,carta_credito\nMario Rossi,mario@esempio.it,4111-1111-1111-1111\n"
  content_type = "text/csv"
}

# ---------------------------------------------------------------------------
# 3) SSM — segreto salvato come String (testo in chiaro) invece di SecureString
#    Controllo ISO violato: crittografia dei dati a riposo
# ---------------------------------------------------------------------------

resource "aws_ssm_parameter" "db_password" {
  name  = var.ssm_param_name
  type  = "String"
  value = var.ssm_param_value
}
