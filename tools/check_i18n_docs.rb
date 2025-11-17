#!/usr/bin/env ruby
# frozen_string_literal: true

#
# Bilingual Documentation Line Count Verification Script
#
# This script verifies that all English documentation files have corresponding
# Russian translations with exactly matching line counts.
#
# Usage:
#   ruby tools/check_i18n_docs.rb
#
# Exit codes:
#   0 - All documentation is in sync
#   1 - Line count mismatches found
#

require 'pathname'

class BilingualDocsChecker
  def initialize(root_path = '.')
    @root = Pathname.new(root_path)
    @errors = []
    @checked_count = 0
  end

  def run
    puts "🔍 Checking bilingual documentation line counts..."
    puts "=" * 80
    
    find_english_docs.each do |en_file|
      check_file_pair(en_file)
    end
    
    print_results
    exit(@errors.empty? ? 0 : 1)
  end

  private

  def find_english_docs
    # Find all .md files that are NOT Russian versions (don't end with -RU.md)
    Dir.glob(@root.join('**/*.md').to_s).reject do |path|
      path.end_with?('-RU.md') || path.include?('/node_modules/') || path.include?('/.git/')
    end.sort
  end

  def check_file_pair(en_file_path)
    en_file = Pathname.new(en_file_path)
    ru_file = Pathname.new(en_file_path.sub(/\.md$/, '-RU.md'))
    
    # Skip if this file doesn't need a Russian version (like CHANGELOG, etc.)
    return if skip_file?(en_file)
    
    unless ru_file.exist?
      @errors << {
        type: :missing,
        en_file: relative_path(en_file),
        message: "Missing Russian version"
      }
      return
    end
    
    en_lines = count_lines(en_file)
    ru_lines = count_lines(ru_file)
    
    @checked_count += 1
    
    if en_lines != ru_lines
      @errors << {
        type: :mismatch,
        en_file: relative_path(en_file),
        ru_file: relative_path(ru_file),
        en_lines: en_lines,
        ru_lines: ru_lines,
        diff: ru_lines - en_lines
      }
    else
      puts "✅ #{relative_path(en_file)} <-> #{relative_path(ru_file)} (#{en_lines} lines)"
    end
  end

  def skip_file?(file)
    # Files that don't need Russian versions
    skip_patterns = [
      'CHANGELOG',
      'LICENSE',
      'AGENTS',
      '.github/workflows/',
      '.github/ISSUE_TEMPLATE/',
      '.github/PULL_REQUEST_TEMPLATE',
      'node_modules/',
      'vendor/',
      'spec/',
      'test/'
    ]
    
    skip_patterns.any? { |pattern| file.to_s.include?(pattern) }
  end

  def count_lines(file)
    File.readlines(file).count
  end

  def relative_path(file)
    file.relative_path_from(@root).to_s
  end

  def print_results
    puts "=" * 80
    puts ""
    
    if @errors.empty?
      puts "✅ SUCCESS: All #{@checked_count} documentation pairs are in sync!"
      puts ""
      puts "All English documentation files have matching Russian translations"
      puts "with identical line counts."
    else
      puts "❌ ERRORS FOUND: #{@errors.length} documentation pair(s) out of sync"
      puts ""
      
      @errors.each do |error|
        case error[:type]
        when :missing
          puts "❌ MISSING: #{error[:en_file]}"
          puts "   #{error[:message]}"
          puts "   Expected: #{error[:en_file].sub(/\.md$/, '-RU.md')}"
        when :mismatch
          puts "❌ MISMATCH: #{error[:en_file]}"
          puts "   English:  #{error[:en_lines]} lines"
          puts "   Russian:  #{error[:ru_lines]} lines"
          puts "   Diff:     #{error[:diff] > 0 ? '+' : ''}#{error[:diff]} lines"
        end
        puts ""
      end
      
      puts "=" * 80
      puts ""
      puts "HOW TO FIX:"
      puts ""
      puts "1. For MISSING files:"
      puts "   - Create the Russian version: {filename}-RU.md"
      puts "   - Translate the English content to Russian"
      puts "   - Ensure line-by-line correspondence"
      puts ""
      puts "2. For MISMATCH files:"
      puts "   - Open both English and Russian files side-by-side"
      puts "   - Add/remove lines in Russian to match English structure"
      puts "   - Verify content is fully translated"
      puts "   - Re-run this script to verify"
      puts ""
      puts "GUIDELINES:"
      puts ""
      puts "- English file is the PRIMARY source of truth"
      puts "- Russian file must have IDENTICAL structure"
      puts "- Same number of lines, same heading levels"
      puts "- Blank lines must match exactly"
      puts "- Code blocks must have same line count"
      puts ""
      puts "See: .github/instructions/i18n-docs.md"
    end
    
    puts "=" * 80
  end
end

# Run the checker
BilingualDocsChecker.new.run
