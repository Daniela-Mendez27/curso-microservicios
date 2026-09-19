#!/bin/bash

cd ..

if [ -d "microservicios" ]; then
    rm -rf microservicios
    echo "Carpeta anterior eliminada para empezar limpio"
fi

mkdir -p microservicios
cd microservicios

projectsList=("GetAdults" "GetChildren" "GetAdultById" "GetChildById" "AddMember" "PickAge" "AddChild" "AddAdult")

for project in "${projectsList[@]}"; do
    # -o crea la subcarpeta con el nombre del proyecto
    dotnet new webapi -n "$project" -o "$project" --force
    
    # Escribe el Dockerfile directamente dentro de esa subcarpeta
    cat <<EOF > "$project/Dockerfile"
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY $project.csproj .
RUN dotnet restore
COPY . .

RUN dotnet build "$project.csproj" -c Release -o /app/build
RUN dotnet publish -c Release -o /app

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "$project.dll"]
EOF

done

echo "¡Listo! Microservicios y Dockerfiles generados."