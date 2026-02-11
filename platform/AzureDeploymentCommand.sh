az deployment sub create  \
  --location northeurope \
  --template-file ./bicep/main.bicep \
  --parameters prefix=mypr env=dev

