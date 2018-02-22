import re
import sys

def feat1( str ):
	search_list = ['I', 'me', 'my', 'mine', 'we', 'us', 'our', 'ours']
	return count_occurance_word(str, search_list)

def feat2( str ):
	search_list = ['you', 'your', 'yours', 'u', 'ur', 'urs']
	return count_occurance_word(str, search_list)

def feat3( str ):
	search_list = ['he', 'him', 'his', 'she', 'her', 'hers', 'it', 'its', \
				   'they', 'them', 'their', 'theirs']
	return count_occurance_word(str, search_list)

def feat4( str ):
	search_list = ['CC']
	return count_occurance_tag(str, search_list)

def feat5( str ):
	search_list = ['VBD']
	return count_occurance_tag(str, search_list)

def feat6( str ):
	search_list = ['\'ll', 'will', 'gonna', 'going/VBG to']
	return count_occurance_word(str, search_list)

def feat7( str ):
	search_list = [',']
	return count_occurance_punc(str, search_list)

def feat8( str ):
	search_list = [':', ';']
	return count_occurance_punc(str, search_list)

def feat9( str ):
	search_list = ['-']
	return count_occurance_punc(str, search_list)

def feat10( str ):
	search_list = ['(', ')']
	return count_occurance_punc(str, search_list)

def feat11( str ):
	search_list = ['...']
	return count_occurance_punc(str, search_list)

def feat12( str ):
	search_list = ['NN', 'NNS']
	return count_occurance_tag(str, search_list)

def feat13( str ):
	search_list = ['NNP', 'NNPS']
	return count_occurance_tag(str, search_list)

def feat14( str ):
	search_list = ['RB', 'RBR', 'RBS']
	return count_occurance_tag(str, search_list)

def feat15( str ):
	search_list = ['WDT', 'WP', 'WP$', 'WRB']
	return count_occurance_tag(str, search_list)

def feat16( str ):
	search_list_string = 'smh,fwb,lmfao,lmao,lms,tbh,rofl,wtf,bff,wyd,lylc,brb,\
	atm,imao,sml,btw,bw,imho,fyi,ppl,sob,ttyl,imo,ltr,thx,kk,omg,ttys,afn,bbs,\
	cya,ez,f2f,gtr,ic,jk,k,ly,ya,nm,np,plz,ru,so,tc,tmi,ym,ur,u,sol'
	search_list = search_list_string.split(',')
	return count_occurance_word(str, search_list)

def feat17( str ):
	''' words all in upper case'''
	result = 0
	str_list = str.split()
	for s in str_list:
		start_idx = s.find('/')
		if s.isupper() and start_idx >= 2:
			result += 1
	return result

def feat18( str ):
	sentences_list = str.split('\n')
	total = 0.0
	length = 0.0
	for sentences in sentences_list:
		if len(sentences) < 2:
			continue
		length += 1
		total += len(sentences.split())

	if length == 0:
		return 0
	return total/length

def feat19( str ):
	p_list = ['./', ',/', ':/', '?/', '!/', ';/', ')/', '(/']
	token_list = str.split()
	total = 0.0
	number = 0.0
	for token in token_list:
		if len(token) < 2:
			continue
		if any(p in token for p in p_list):
			continue
		start_idx = token.find('/')
		number += 1
		total += start_idx

	if number == 0:
		return 0
	return total/number

def feat20( str ):
	return str.count('\n')

'''
The following are helper functions
'''

def count_occurance_word( str, word_list):
	'''
	This is the helper function for counting certain word occurance in
	a string. It will first change string to lower cases to ignore the case.
	Then it will add space before the word and a slash after word.
	'''
	str = ' ' + str.lower()
	result = 0
	for w in word_list:
		w = w.lower()
		word_to_search = ' ' + w + '/'
		result += str.count(word_to_search)
		word_to_search = '\n' + w + '/'
		result += str.count(word_to_search)

	return result

def count_occurance_tag( str, tag_list):
	'''
	This is the helper function for counting certain tag occurance in
	a string. 
	'''
	result = 0
	for t in tag_list:
		tag_to_search = '/' + t + ' '
		result += str.count(tag_to_search)

	return result

def count_occurance_punc( str, punc_list):
	'''
	This is the helper function for counting certain punctuation occurance in
	a string. 
	'''
	result = 0
	for p in punc_list:
		punc_to_search = ' ' + p + '/'
		result += str.count(punc_to_search)

	return result

def output_features(string_list, of, num_lines, polarity):
	for i in range(0, num_lines):
		#of.write(string_list[i])
		of.write(str(feat1(string_list[i])) + ', ' +
				 str(feat2(string_list[i])) + ', ' +
		         str(feat3(string_list[i])) + ', ' +
		         str(feat4(string_list[i])) + ', ' +
		         str(feat5(string_list[i])) + ', ' +
		         str(feat6(string_list[i])) + ', ' +
		         str(feat7(string_list[i])) + ', ' +
		         str(feat8(string_list[i])) + ', ' +
		         str(feat9(string_list[i])) + ', ' +
		         str(feat10(string_list[i])) + ', ' +
		         str(feat11(string_list[i])) + ', ' +
		         str(feat12(string_list[i])) + ', ' +
		         str(feat13(string_list[i])) + ', ' +
		         str(feat14(string_list[i])) + ', ' +
		         str(feat15(string_list[i])) + ', ' +
		         str(feat16(string_list[i])) + ', ' +
		         str(feat17(string_list[i])) + ', ' +
		         str(feat18(string_list[i])) + ', ' +
		         str(feat19(string_list[i])) + ', ' +
		         str(feat20(string_list[i])) + ', ' +
		         polarity + '\n')

def main():
	if len(sys.argv) != 3 and len(sys.argv) != 4:
		print "This program can take two or three arguments."
		sys.exit(1)
	input_file = sys.argv[1]
	output_file = sys.argv[2]

	if len(sys.argv) == 4:
		maxlines_per_class = int(sys.argv[3])
	else:
		maxlines_per_class = 10000

	with open(input_file, 'r') as twt_file:
		raw_data = twt_file.readlines()
		negative_list = []
		positive_list = []
		i = 0
		while i < len(raw_data):
			if raw_data[i] == '<A=4>\n':
				polarity = 4
			elif raw_data[i] == '<A=0>\n':
				polarity = 0
			i += 1
			start = i
			while i < len(raw_data) and ('<A=' not in raw_data[i]):
				i += 1
			end = i;
			s = ''.join(raw_data[start:end])
			if polarity == 4:
				positive_list.append(s)
			if polarity == 0:
				negative_list.append(s)

		ofile = open(output_file, 'w')
		ofile.write('@RELATION TweeterFeatures\n\n')
		ofile.write('@ATTRIBUTE "First person pronouns"  numeric\n')
		ofile.write('@ATTRIBUTE "Second person pronouns"  numeric\n')
		ofile.write('@ATTRIBUTE "Third person pronouns"  numeric\n')
		ofile.write('@ATTRIBUTE "Coordinating conjunctions"  numeric\n')
		ofile.write('@ATTRIBUTE "Past-tense verbs"  numeric\n')
		ofile.write('@ATTRIBUTE "Future-tense verbs"  numeric\n')
		ofile.write('@ATTRIBUTE "Commas"  numeric\n')
		ofile.write('@ATTRIBUTE "Colons and semi-colons"  numeric\n')
		ofile.write('@ATTRIBUTE "Dashes"  numeric\n')
		ofile.write('@ATTRIBUTE "Parentheses"  numeric\n')
		ofile.write('@ATTRIBUTE "Ellipses"  numeric\n')
		ofile.write('@ATTRIBUTE "Common nouns"  numeric\n')
		ofile.write('@ATTRIBUTE "Proper nouns"  numeric\n')
		ofile.write('@ATTRIBUTE "Adverbs"  numeric\n')
		ofile.write('@ATTRIBUTE "wh-words"  numeric\n')
		ofile.write('@ATTRIBUTE "Modern slang acronyms"  numeric\n')
		ofile.write('@ATTRIBUTE "Words all in upper case"  numeric\n')
		ofile.write('@ATTRIBUTE "Average length of sentences"  numeric\n')
		ofile.write('@ATTRIBUTE "Average length of tokens"  numeric\n')
		ofile.write('@ATTRIBUTE "Number of sentences"  numeric\n')
		ofile.write('@ATTRIBUTE "class"  {0, 4}\n\n')

		ofile.write('@DATA\n')
		
		maxlines_negative = min(maxlines_per_class, len(negative_list))
		maxlines_positive = min(maxlines_per_class, len(positive_list))
		output_features(positive_list, ofile, maxlines_positive, '4')
		output_features(negative_list, ofile, maxlines_negative, '0')
		

if __name__== "__main__":
	main()


