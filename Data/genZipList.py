
def main():
	filename=open("RawZipData.txt", "r")
	lines=filename.readlines()
	output=open("zipList.txt", "w")
	print len(lines)
	for line in lines:
		words=line.strip().split("\t")
		if len(words) > 2:
			print words[0]+"\t"+words[1]
			output.write(words[0]+"\t"+words[1]+"\tfalse"+"\n")
	output.close()

if __name__ == '__main__':
	main()