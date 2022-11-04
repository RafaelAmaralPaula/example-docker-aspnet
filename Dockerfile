

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DevFreela.Api/DevFreela.Api.csproj", "DevFreela.Api/"]
COPY ["DevFreela.Application/DevFreela.Application.csproj", "DevFreela.Application/"]
COPY ["DevFreela.Domain/DevFreela.Domain.csproj", "DevFreela.Domain/"]
COPY ["DevFreela.Infrastructure/DevFreela.Infrastructure.csproj", "DevFreela.Infrastructure/"]
RUN dotnet restore "DevFreela.Api/DevFreela.Api.csproj"
COPY . .
WORKDIR "/src/DevFreela.Api"
RUN dotnet build "DevFreela.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DevFreela.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DevFreela.Api.dll"]