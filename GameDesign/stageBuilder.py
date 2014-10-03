import xml.etree.ElementTree as ET

def createTxtMatrix (fileName, node):
	f = open (fileName, 'w')
	f.truncate()
	width = int (node.attrib['width'])
	height = int (node.attrib['height'])
	
	if fileName == "fundo.txt":
		f2 = open ("iluminacao.txt", 'w')
		f2.truncate()
	
	for i in range (height):
		for j in range(width):
			f.write(node[0][i * width + j].attrib['gid'])
			if fileName == "fundo.txt":
				if node[0][i * width + j].attrib['gid'] == "0":
					f2.write("0");
				else:
					f2.write("1");
			if j + 1 != width:
				f.write(",")
				if fileName == "fundo.txt":
					f2.write(",")
		if i + 1 != height:
			f.write("\n")
			if fileName == "fundo.txt":
				f2.write("\n")
	f.close()

tree = ET.parse('ruina.tmx')
root = tree.getroot()

for child in root:
	if child.tag == "layer" and child.attrib['name'] == "fundo":
		createTxtMatrix ("fundo.txt", child)
	if child.tag == "layer" and child.attrib['name'] == "decoracao":
		createTxtMatrix ("decoracao.txt", child)
	if child.tag == "layer" and child.attrib['name'] == "tiles":
		createTxtMatrix ("fase.txt", child)
