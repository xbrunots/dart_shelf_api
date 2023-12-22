echo "========================";
echo "Baixando versão mais atual da API Tinpets";
echo "========================";
git pull;
echo "========================";
echo "Subindo container";
echo "========================";
docker compose up --force-recreate --build -d;
