FROM microsoft/aspnetcore:2.1 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.1 AS build
WORKDIR /src
COPY *.sln ./
COPY aspHello/aspHello.csproj aspHello/
RUN dotnet restore
COPY . .
WORKDIR /src/aspHello
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "aspHello.dll"]
