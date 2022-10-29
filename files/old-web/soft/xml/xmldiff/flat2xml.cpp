// This Code is under the GPL.
// (c) 2003 - Rémi Peyronnet <remi.peyronnet@via.ecp.fr>
//
// flat2xml.cpp : Defines the entry point for the console application.
//

#pragma  warning (disable:4786)

#include <string>
#include <stack>
#include <ios>
#include <iostream>
#include <fstream>
#include <sstream>

#define EL_SLASH '/'
#define EL_ATT_START '['
#define EL_ATT_STOP ']'
#define EL_ATT_SEP ','
#define EL_ATT_ID '@'
#define EL_ATT_QUOTE '"'
#define EL_VALUE '='
#define CH_INDENT "  "
#define MAX_LINE_LEN 65535

enum state { IN_ELEMENT, IN_ATTLIST, IN_ATT, IN_VALUE };

using namespace std;

int xmlOutput(ofstream & fileout, string & str, bool open, int indent = 0)
{
	int i;
	int lastItem = 0;
	enum state curState = IN_ELEMENT;
	stack<string> elements;
	ostringstream strout;
	ostream * fout;
	string strIndent = "";

	curState = IN_ELEMENT;
	
	for (int j = 0; j < indent; j++) strIndent += CH_INDENT;

	if (open)
	{
		fout = &fileout; 
	}
	else
	{
		fout = &strout;
	}

	for (i = 0; i < str.size(); i++)
	{
		if ((curState == IN_ELEMENT) && (str[i] == EL_SLASH))
		{ 
			lastItem = i;
		}
		if ((curState == IN_ELEMENT) && (str[i] == EL_ATT_START))
		{
			*fout << strIndent << (open?"<":"</") << str.substr(lastItem + 1, i - lastItem - 1);
			lastItem = i;
			strIndent += CH_INDENT;
			curState = IN_ATTLIST;
		}
		if ((curState == IN_ATTLIST    ) && (str[i] == EL_ATT_STOP)) 
		{
			*fout << string(">") << endl;
			if (!open)
			{
				elements.push(string(strout.str()));
				strout.str("");
			}
			curState = IN_ELEMENT;
		}
        if (str[i] == EL_ATT_QUOTE)
        {
            if (curState == IN_ATTLIST )  curState = IN_ATT;
            else if (curState == IN_ATT ) curState = IN_ATTLIST;
        }
		if ((curState == IN_ATTLIST ) && (str[i] == EL_ATT_SEP))
		{
			if ( (str[lastItem+1] == EL_ATT_ID) && (open)) *fout << " " << str.substr(lastItem + 2, i - lastItem - 2);
			lastItem = i;
		}
		if ((curState == IN_ELEMENT) && (str[i] == EL_VALUE)) 
		{
			lastItem = i; 
			if ((open) && (i != str.size() - 1))
			{
				*fout << strIndent << CH_INDENT << str.substr(lastItem + 1, str.size() - (lastItem + 1)) << endl;
			}
			curState = IN_VALUE; 
			break;
		}
	}
	if(!open)
	{
		string elem;
		while(elements.size() > 0)
		{
			elem = elements.top();
			fileout << elem;
			elements.pop();
		}
	}
	return 0;
}


int flat2xml(const char * inFile, const char * outFile)
{
	enum state curState;

	ifstream fin(inFile);
	ofstream fout(outFile);

	string curLine, lastLine;
	char temp[MAX_LINE_LEN];
	int i, len, lastItem, indent = -1;

	lastLine = "";

	// Read the file
	while (!fin.eof())
	{
		fin.getline(temp, MAX_LINE_LEN);
		curLine = temp;
		curState = IN_ELEMENT;
		// Process the current line
		len = (curLine.size() < lastLine.size()) ? curLine.size() : lastLine.size();
		lastItem = 0;
		i = 0;
		indent = -1;
		for (i = 0; i < len; i++)
		{
			if ((curState == IN_ELEMENT) && (curLine[i] == EL_SLASH)) { indent++; lastItem = i;}
			if ((curState == IN_ELEMENT) && (curLine[i] == EL_ATT_START)) curState = IN_ATT;
			if ((curState == IN_ATT    ) && (curLine[i] == EL_ATT_STOP)) curState = IN_ELEMENT;
			if ((curState == IN_ELEMENT) && (curLine[i] == EL_VALUE)) { curState = IN_VALUE; lastItem = i; }
			if (curLine[i] != lastLine[i]) i = len + 1;
		}
		// Close and open tags
		if (curState != IN_VALUE)
		{
			xmlOutput(fout, lastLine.substr(lastItem),false, indent);
			xmlOutput(fout, curLine.substr(lastItem),true, indent);
		}
		else
		{
			xmlOutput(fout, curLine.substr(lastItem),true, indent+1);
			// fout << curLine.substr(lastItem+1) << endl;
		}
		lastLine = curLine;
	}
	return 0;
}

int main(int argc, char* argv[])
{
	int ret;
	printf("flat2xml : Convert flat xml to hierarchical xml (see xml2flat.xsl)\n");
	printf("flat2xml v0.1.0 (c) 2003 - Remi Peyronnet.\n");
	if (argc != 3)
	{
		printf("Usage : flat2xml <flat_file> <xml_file>\n");
		ret = -1;
	}
	else 
	{
		ret = flat2xml(argv[1], argv[2]);
		printf("Done.\n");
	}
	return ret;
}

