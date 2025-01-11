#!/bin/bash

# Vérification des paramètres
if [ -z "$1" ]; then
  echo "Usage: ./create-bundle.sh NomDuBundle"
  exit 1
fi

BUNDLE_NAME="$1"
BUNDLE_NAMESPACE="App\\${BUNDLE_NAME}"
BUNDLE_DIR="src/${BUNDLE_NAME}"
BUNDLES_FILE="config/bundles.php"
ROUTES_FILE="config/routes.yaml"

# Étape 1 : Création de la structure du bundle
echo "Création du bundle ${BUNDLE_NAME}..."
mkdir -p "${BUNDLE_DIR}"

# Création du fichier de classe du bundle
cat <<EOL > "${BUNDLE_DIR}/${BUNDLE_NAME}.php"
<?php

namespace ${BUNDLE_NAMESPACE};

use Symfony\Component\HttpKernel\Bundle\Bundle;

class ${BUNDLE_NAME} extends Bundle
{
}
EOL
echo "Fichier ${BUNDLE_NAME}.php créé."

# Étape 2 : Enregistrement dans bundles.php
if ! grep -q "${BUNDLE_NAMESPACE}\\${BUNDLE_NAME}" "${BUNDLES_FILE}"; then
  sed -i "/return \[/a \\    ${BUNDLE_NAMESPACE}\\${BUNDLE_NAME}::class => ['all' => true]," "${BUNDLES_FILE}"
  echo "Bundle enregistré dans ${BUNDLES_FILE}."
else
  echo "Le bundle est déjà enregistré dans ${BUNDLES_FILE}."
fi

# Étape 3 : Enregistrement dans routes.yaml
if ! grep -q "${BUNDLE_NAME}" "${ROUTES_FILE}"; then
  echo "" >> "${ROUTES_FILE}"
  echo "${BUNDLE_NAME}:" >> "${ROUTES_FILE}"
  echo "    resource: '../src/${BUNDLE_NAME}/Controller'" >> "${ROUTES_FILE}"
  echo "    type: annotation" >> "${ROUTES_FILE}"
  echo "Routes ajoutées dans ${ROUTES_FILE}."
else
  echo "Les routes du bundle sont déjà enregistrées dans ${ROUTES_FILE}."
fi

echo "Le bundle ${BUNDLE_NAME} a été créé et enregistré avec succès."
