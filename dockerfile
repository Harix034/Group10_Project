# Use .NET SDK image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /app

# Copy project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy remaining files
COPY . ./

# Publish the app for ARM (Raspberry Pi) architecture
RUN dotnet publish -c Release -r linux-arm --self-contained -o /out

# Final stage to create the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
COPY --from=build /out ./ 

ENTRYPOINT ["dotnet", "MyApp.dll"]
