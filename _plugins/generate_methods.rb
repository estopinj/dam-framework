require 'csv'

module Jekyll
  class MethodGenerator < Generator
    safe true

    def generate(site)
      methods = CSV.read(File.join(site.source, '_data', 'methods.csv'), headers: true)

      methods.each do |row|
        method_name = row['title'].downcase.tr(" ", "-")
        method_path = File.join(site.source, '_methods', "#{method_name}.md")

        # Only create the file if it doesn't exist to avoid overwriting
        next if File.exist?(method_path)

        # Front matter fields from CSV
        front_matter = {
          "title" => row['title'],
          "categories" => row['categories'].split(','),
          "data_type" => row['data_type'].split(','),
          "language" => row['language'].split(','),
          "description" => row['description'],
          "method_content" => ""  # Placeholder for manual content
        }

        # Write the .md file with the front matter
        File.open(method_path, 'w') do |file|
          file.write("---
")
          file.write(front_matter.map { |k, v| "#{k}: #{v.to_yaml.strip}" }.join("
"))
          file.write("
---

")
          file.write(row['description'])  # Add description as part of the content
        end
      end
    end
  end
end
