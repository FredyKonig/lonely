require "rexml/document"

class DestinationObject

  attr_accessor :atlas_id
  attr_accessor :destination
  attr_accessor :paragraphs


  def to_s
    out = "\n atlas_id:#{atlas_id} destination:#{destination}("
    out << paragraphs.each.map { |key, value| ":#{key}=> #{value[0, 20]}.." }.join(",\n")
    out << ")\n"
    out.to_s
  end

  def initialize(atlas_id)
    self.paragraphs =[]
    self.atlas_id = atlas_id.to_s
    puts "initialize DestinationObject"
    load_destination_and_content
  end

  def load_destination_and_content

    doc_destination = REXML::Document.new(File.new("public/xml/destination.xml").read)

    self.destination=REXML::XPath.match(doc_destination, "//destination[@atlas_id='#{atlas_id}']").map { |i| i.attributes["title"] }[0]
    puts "name of destination #{self.destination}"

    destinations=doc_destination.children.select { |i| (!i.to_s.blank? && !i.to_s.include?("?xml") && i.name="destinations") }
    target_destination=destinations[0].children.select { |i| (!i.to_s.blank? && i.name="destination") && i.to_s.include?("#{atlas_id}") }[0]

    # load_all_content(target_destination)
    load_manually(target_destination) #need more time
  end

  # working but should use  load_all_content(destination)
  def load_manually(target_destination)

#     target_destination.children.select{|i| (!i.to_s.blank?) }
#     => [<history> ... </>, <introductory> ... </>, <practical_information> ... </>, <transport> ... </>, <weather> ... </>, <work_live_study> ... </>]
    history=target_destination.children.select { |i| (!i.to_s.blank?) }[0]
#     => <history> ... </>
#    history.children.select { |i| (!i.to_s.blank? && i.cdatas) }[0].name
#     => "history" 
#     history.children.select { |i| (!i.to_s.blank? && i.cdatas) }[0].cdatas
#     => [] 


    title= history.children.select { |i| (!i.to_s.blank? && i.cdatas) }[0].name
    content= history.children.select { |i| (!i.to_s.blank? && i.cdatas) }[0].cdatas
    add_paragraph(title, content)

    history2=history.children.select { |i| (!i.to_s.blank? && i.cdatas) }[0]
    history3=history2.children.select { |i| (!i.to_s.blank? && i.cdatas) }

    #history3 has 13
    history3.each do |node|
      if !node.to_s.blank?
        title=node.name.to_s
        content=node.cdatas.to_s
        add_paragraph(title, content)
      end
    end
  end

# need more time to understand bad cases
  def load_all_content(destination)
    puts "destination = #{destination.to_s[0, 100]}.. #{destination.to_s[(destination.to_s.size-20)..-1]} =end destination"
    destination.children.each do |child|
      if !child.to_s.blank?

        if child.children && child.children.count>1
          load_all_content(child)
        else
          load_paragraph(child)
        end
      end
    end
  end

#  need more time
  def load_paragraph(node)
    begin
      puts "load para with title=node= #{node.to_s[0, 100]}....#{node.to_s[(node.to_s.size-20)..-1]} =end node"
      title=node.children.select { |i| (!i.to_s.blank? && i.cdata?) }[0].name
      #=> "introduction"
      puts "title= #{title}"

      content=node.children.select { |i| (!i.to_s.blank? && i.cdata?) }[0].cdatas.to_s
      #=> []
      puts "content= #{content[0, 20]}..." if content

      add_paragraph(title, content)


    rescue Exception =>ex
      puts "Error = #{ex}"
    end


  end

  def add_paragraph(title="", content="")
    return 0 if title.to_s.blank? or content.to_s.blank?
    paragraph=Hash.new
    paragraph["title"]=title
    paragraph["content"]=content.to_s
    self.paragraphs << paragraph
    puts "added paragraph"
  end


#  ===== extra test  below ======================
  def test

    xmlfile = File.new("public/xml/destination.xml")
    xmldoc = Document.new(xmlfile)

    # Info for the first movie found
    destination = XPath.first(xmldoc, "//destination")
    p destination

    # Print out all the movie types
    XPath.each(xmldoc, "//history") { |e| puts e.text }

    # Get an array of all of the movie formats.
    names = XPath.match(xmldoc, "//overview").map { |x| x.text }
    p names

  end

  # for test only working
  def first_dest
    doc_destination = REXML::Document.new(File.new("public/xml/destination.xml").read)

    first_destination=REXML::XPath.first(doc_destination, "//destination")


    all_atlas_id= REXML::XPath.match(doc_destination, "//destination").map { |i| i.attributes["atlas_id"] }

    all_destinations=REXML::XPath.match(doc_destination, "//destination").map { |i| [i.attributes["atlas_id"], i.attributes["title"]] }

    # all_
    doc_taxonomy = REXML::Document.new(File.new("public/xml/taxonomy.xml").read)
    all_atlas_node_id= REXML::XPath.match(doc_taxonomy, "//node").map { |i| i.attributes["atlas_node_id"] }

  end

  ## not in use  but working
  def DestinationObject.destination_name(atlas_id)
    doc_destination = REXML::Document.new(File.new("public/xml/destination.xml").read)
    REXML::XPath.match(doc_destination, "//destination[@atlas_id='#{atlas_id}']").map { |i| i.attributes["title"] }[0]
  end

  #
  ## not in use  but working
  def DestinationObject.get_overview
    content=Hash.new

    doc_destination = REXML::Document.new(File.new("public/xml/destination.xml").read)
    html_content=""
    content["title"]="Overview"
    content["paragraph"]=REXML::XPath.first(doc_destination, "//overview").cdatas.to_s

    return content

  end


end
