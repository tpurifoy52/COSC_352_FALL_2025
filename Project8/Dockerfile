FROM haskell:9.2

WORKDIR /app

# Copy project files
COPY baltimore-homicides.cabal ./
COPY src/ ./src/
COPY baltimore_homicides_combined.csv ./

# Install dependencies and build
RUN cabal update && \
    cabal build && \
    cabal install --install-method=copy --installdir=/app

# Run the executable
CMD ["./baltimore-homicides"]
