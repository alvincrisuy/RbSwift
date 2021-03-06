content = File.read 'text'
content = content.each_line.map do |line|
  "/// \t" + line.gsub("expect(", "")
      .gsub(').to(equal(', "\t\t#=> ")
      .gsub(').to(beNil(', "\t\t#=> nil")
      .gsub(').to(beTrue(', "\t\t#=> true")
      .gsub(').to(beFalse(', "\t\t#=> false")
      .gsub(').to(beEmpty(', "\t\t#=> \"\"")
      .gsub(/\)\)$/, '')
      .gsub(/^\s+/, '')
end

puts content.join
