# Étape 1: Build du binaire OCaml
FROM ocaml/opam:debian-12 as builder

WORKDIR /marina

COPY marina/ ./

RUN sudo apt update && sudo apt install -y make ocaml ocaml-findlib m4 \
    && opam install ounit2 \
    && make

# Étape 2: Créer une image minimale avec Python + le binaire
FROM python:3.11-slim

# Installer dépendances Python
COPY requirements.txt .
RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt

# Copier l'API et le binaire OCaml compilé
COPY app.py .
COPY certs/ certs/
COPY --from=builder /marina/marina ./marina

# Rendre le binaire exécutable
RUN chmod +x ./marina

EXPOSE 80

CMD ["python", "app.py"]