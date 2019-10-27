#if 0
	csv2tex is part of https://github.com/rhasqx/kihon

	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
#endif

#include <cxxopts.hpp>
#include <algorithm>
#include <exception>
#include <fstream>
#include <iostream>
#include <regex>
#include <string>

int main(int argc, char* argv[])
{
	std::string input;

	cxxopts::Options options(argv[0], "transform CSV into (Xe)LaTeX");
		options
			.positional_help("[optional args]")
			.show_positional_help();
		options
			.allow_unrecognised_options()
			.add_options()
			("i, input", "Input csv file", cxxopts::value<std::string>(), "FILE")
			("help", "Print help")
		;
	try {
		auto result = options.parse(argc, argv);
		if (result.count("input"))
		{
			input = result["input"].as<std::string>();
		}
		else
		{
			std::cerr << "Error: No input file." << std::endl << std::endl
					  << options.help({"", "Group"}) << std::endl;
			exit(-1);
		}
		if (result.count("help"))
		{
			std::cout << options.help({"", "Group"}) << std::endl;
			exit(0);
		}
	} catch (const cxxopts::OptionException& e) {
		std::cout << "error parsing options: " << e.what() << std::endl;
		exit(1);
	}
	
	const std::string newline = "\n";
	const std::string tab = "    ";
	const std::string delim = ";";

	std::vector<std::string> header;
	std::vector<std::string> tokens;
	std::ifstream ifs(input);
    std::string line; 
	auto i = 0;

	auto course = -1;
	auto number = -1;
	auto created_at = -1;
	auto hiragana = -1;
	auto katakana = -1;
	auto kanji = -1;
	auto german = -1;
	auto pos = -1;
	auto key = -1;
	auto updated_at = -1;

	auto replace = [](const std::string& haystack){
		const auto str = std::regex_replace(haystack, std::regex("☐"), "\\inputplaceholder");
		return str.size()
			? str
			: "$\\cdot$";
	};

	auto split = [&delim, &header, &course, &number, &created_at, &hiragana, &katakana, &kanji, &german, &pos, &key, &updated_at](std::vector<std::string>& dst, const std::string& line){
		auto start = 0U;
		auto end = line.find(delim);
		while (end != std::string::npos)
		{
			dst.push_back(line.substr(start, end - start));
			start = end + delim.length();
			end = line.find(delim, start);
		}

		if (dst == header)
		{
			auto index = [](const std::vector<std::string>& haystack, const std::string& needle){
				const auto it = std::find(haystack.begin(), haystack.end(), needle);
				return (it == haystack.end())
					? -1
					: std::distance(haystack.begin(), it);
			};

			course = index(header, "course");
			number = index(header, "number");
			created_at = index(header, "created_at");
			hiragana = index(header, "hiragana");
			katakana = index(header, "katakana");
			kanji = index(header, "kanji");
			german = index(header, "german");
			pos = index(header, "pos");
			key = index(header, "key");
			updated_at = index(header, "updated_at");
		}
	};

	std::cout << "\\newcommand{\\token}[2]{"
			  << "\\begin{switch}{#1}" << newline;

    while (std::getline(ifs, line))
    {
		tokens.clear();
		split(i++ == 0 ? header : tokens, line);

		try {
			if (tokens.at(key).size() <= 0)
				continue;

			std::cout << "\\case{" << tokens.at(key)
					  << "}{" << newline
					  << tab << "\\begin{switch}{#2}" << newline
					  << tab << tab << "\\case{kanji}{\\textcolor{kanji}{" << replace(tokens.at(kanji)) << "}}" << newline
					  << tab << tab << "\\case{hiragana}{\\textcolor{hiragana}{" << replace(tokens.at(hiragana)) << "}}" << newline
					  << tab << tab << "\\case{katakana}{\\textcolor{katakana}{" << replace(tokens.at(katakana)) << "}}" << newline
					  << tab << tab << "\\case{romaji}{\\textcolor{romaji}{" << "todo" << "}}" << newline
					  << tab << tab << "\\case{german}{\\textcolor{german}{" << replace(tokens.at(german)) << "}}" << newline
					  << tab << "\\end{switch}" << newline
					  << "}" << newline;
		} catch(...) {
			// nil -- just ignore if it isincomplete
		}
    }
	
	std::cout << "\\end{switch}" << "}" << newline;

	return 0;
}
