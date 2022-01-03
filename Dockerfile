#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["rpm-to-miles-blazor.csproj", "."]
RUN dotnet restore "./rpm-to-miles-blazor.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "rpm-to-miles-blazor.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "rpm-to-miles-blazor.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "rpm-to-miles-blazor.dll"]