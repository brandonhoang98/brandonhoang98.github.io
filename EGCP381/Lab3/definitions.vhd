library ieee;
use ieee.std_logic_1164.all;

package definitions is
	-- Cache
	constant cache_tag_width : positive := 4;		-- 4-bit Tag
	constant cache_line_width : positive := 4;	-- 4-bit Line
	constant cache_word_width : positive := 2;	-- 2-bit Word
	constant cache_data_width : positive := (cache_tag_width + 2**5);	-- Data width (tag + 32-bit data)
	constant cache_len : positive := 2**cache_line_width;			-- 2^line cache
	
	-- Main Memory
	constant main_mem_adr_width : positive := cache_tag_width + cache_line_width;
	constant main_mem_data_width : positive := 2**5;	-- 32-bit data
	constant main_mem_len : positive := 2**(cache_tag_width + cache_line_width);
end definitions;

package body definitions is

 
end definitions;
