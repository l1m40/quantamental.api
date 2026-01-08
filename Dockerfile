FROM --platform=linux/amd64 rocker/r2u:jammy

# ---- system dependencies ----
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libsodium-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# ---- working directory ----
WORKDIR /app

# ---- copy source ----
COPY . /app

# ---- install renv ----
RUN R -e "install.packages('renv')"

# ---- restore R packages (r2u binaries) ----
RUN R -e "renv::restore()"

# ---- install API package ----
RUN R -e "install.packages('.', repos = NULL, type = 'source')"

# ---- expose port ----
EXPOSE 8080

# ---- start plumber ----
CMD ["R", "-e", "plumber::plumb('inst/plumber/plumber.R')$run(host='0.0.0.0', port=8080)"]
