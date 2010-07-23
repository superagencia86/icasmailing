def xhtml2pdf(input_file, output_file)
  
  java_dir = File.join(File.expand_path(File.dirname(__FILE__)), "java")
  jar_dir = File.join(java_dir, "jar")
  
  class_path = ".#{JAVA_OPTIONS[:cp_separator]}\"#{java_dir}\""
  
  Dir.foreach(jar_dir) do |jar|
    class_path << "#{JAVA_OPTIONS[:cp_separator]}\"#{jar_dir}/#{jar}\"" if jar.match(/\.jar/)  
  end
  
  command = "#{JAVA_OPTIONS[:bin]} -cp #{class_path} Xhtml2Pdf \"#{input_file}\" \"#{output_file}\""
  puts command
  system(command)
end