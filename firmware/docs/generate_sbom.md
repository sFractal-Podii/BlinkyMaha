# Background

This guide will assist in the process of generating a Software Bill-of-Materials (SBoM) for Mix projects, in [CycloneDX format](https://cyclonedx.org/).


## Installation

The package has been added to the project's dependencies to make the `Mix task` available.

```elixir

def deps do

{:sbom,
       git: "https://github.com/sigu/sbom.git",
       only: :dev,
       branch: "auto-install-bom",
       runtime: false}
end

```

The [git branch](https://github.com/sigu/sbom.git) used automates the following task in this project:

  1. Generating Elixir bom
  2. Installation of cyclonedx
  3. Converting bom file to different formats(spdx, json e.t.c)


  ## Steps

  To successfully generate an SBOM file, follow the following steps

  ### 1. Install Cyclonedx

  If you don't have cyclonedx cli added to the project, run the command in your terminal. 

  ```shell
  mix sbom.install

  ```
  It will install cyclonedx cli compatible with your Operating System under the `_build/` directory.

  ### 2. Generating Elixir bom

  To generate CycloneDx Sbom, run the command in your terminal

  ```shell
   mix sbom.cyclonedx
  ```

  The result will be written to a file named `bom.xml` by default. You can specify a different name using the `-o` option 

  ```shell
   mix sbom.cyclonedx -o another_bom.xml

   ```

   ### 3. Convert Bom file to a different format

   To convert the bom file generated, run the command in your terminal

   ```shell
   mix sbom.convert

   ```

   The converted files will be written in the root directory of the project. The files will be converted to `json`, `xml` and `spdx` format.

   By default, the command converts a file named `bom.xml`. To specify a file with a different name, add `-i` option.

   ```shell
   mix sbom.convert -i another_bom.xml
   
   ```

   ### Generated SBOM files Attached in release

   