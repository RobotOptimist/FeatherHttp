$version = "Default"
if (Get-Command "nbgv.exe" -ErrorAction SilentlyContinue) {
    #if testing locally you will need to install nbgv
    #dotnet tools install -g nbgv
    $version = nbgv get-version -v NugetPackageVersion;
}
elseif (Get-Command "./nbgv.exe" -ErrorAction SilentlyContinue) {
    $version = ./nbgv get-version -v NugetPackageVersion;    
}
if (!$version) { $version = "Default" }
if ($version -ne "Default") {
    $nuspecXml = [xml](Get-Content ./template/FeatherHttpTemplate.nuspec)
    $nuspecXml.selectNodes("//version") | ForEach-Object {
      $_."#text" = $version.ToString()
      Write-Host "Updated nuspec"
    }
    $nuspecXml.save("./template/FeatherHttpTemplate.nuspec")
    $csprojXml = [xml](Get-Content ./template/content/featherhttp-template.csproj)
    $csprojXml.selectNodes("//PackageReference") | ForEach-Object {
      $_.Version = $version.ToString()
      Write-Host "Updated csproj"
    }
    $csprojXml.save("./template/content/featherhttp-template.csproj")
}