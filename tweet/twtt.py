import re
import HTMLParser
import NLPlib
import sys
import csv

def elimate_ord(s):
	if ord(s) < 128:
		return s
	else:
		return ''

def twtt1(s):
  	return re.sub(r'<.*?>', '', s)

def twtt2(s):
	'''
	http://stackoverflow.com/questions/275174/how-do-i-perform-html-decoding-encoding-using-python-django
	http://stackoverflow.com/questions/20078816/replace-non-ascii-characters-with-a-single-space
	'''
	s = ''.join([i if ord(i) < 128 else '' for i in s])
	parser = HTMLParser.HTMLParser()
	s = parser.unescape(s)
	return s

def twtt3(s):
	s = re.sub(r'http\S+', '', s)
	return re.sub(r'www\S+', '', s)

def twtt4(s):
	s = re.sub('@', '', s)
	return re.sub('#', '', s)

def twtt5(s):
	s = re.sub(r'(\.{2,})', r' \1 ', s)
	s = re.sub(r'(\?{2,})', r' \1\n', s)
	s = re.sub(r'(\!{2,})', r' \1\n', s)
	s = re.sub(r'([a-zA-Z0-9])([.?!])', r'\1 \2\n', s)
	return s

def twtt7(s):
	s = re.sub(r'([a-zA-Z0-9])([,;:()])', r'\1 \2', s)
	s = re.sub(r'([,;:()])([a-zA-Z0-9])', r'\1 \2', s)
	s = re.sub(r'([a-zA-Z])(\'s)', r'\1 \2', s)
	s = re.sub(r's\'', "s '", s)
	return s

def twtt8(s, tagger):
	''' Tag token

		Return: sing tagged with tag
	'''
	result = ''
	sentence = s.split('\n')
	for se in sentence:
		if len(se) == 0:
			continue
		tokens = se.split();
		tags = tagger.tag(tokens)
		for i in range(0, len(tags)):
			result += tokens[i] + '/' + tags[i] + ' '
		result += '\n'
	return result

def twtt9(obj):
	''' Attach demarcation
	'''
	return obj[0]

def main():
	if len(sys.argv) != 4:
		print "This program accepts 3 arguments."
		sys.exit(1)

	csv_file = sys.argv[1]
	studentID = int(sys.argv[2])
	output_file = sys.argv[3]

	with open(csv_file, 'r') as csvfile:
		raw_data = list(csv.reader(csvfile))
		if len(raw_data) > 10000:
			student_module = studentID % 80
			data = raw_data[student_module * 10000: (student_module + 1) * 10000]
			data.extend(raw_data[800000 + student_module * 10000: 800000 + (student_module + 1) * 10000])
		else:
			data = raw_data
		print len(data)
		tagger = NLPlib.NLPlib()
		output = open(output_file, 'w')
		for row in data:
			output.write('<A=' + twtt9(row) + '>\n')
			output.write(twtt8(twtt7(twtt5(twtt4(twtt3(twtt2(twtt1(row[5])))))), tagger))
		
if __name__== "__main__":
	main()








