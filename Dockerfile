FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5030

ENV ASPNETCORE_URLS=http://+:5030

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["apidatabase/apidatabase.csproj", "apidatabase/"]
RUN dotnet restore "apidatabase\apidatabase.csproj"
COPY . .
WORKDIR "/src/apidatabase"
RUN dotnet build "apidatabase.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "apidatabase.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "apidatabase.dll"]
