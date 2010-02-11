module PdfRenderer
  module Helpers
    module LatexHelper
      BS        = "\\\\"
      BACKSLASH = "#{BS}textbackslash{}"
      HAT       = "#{BS}textasciicircum{}"
      TILDE     = "#{BS}textasciitilde{}"

      def latex_escape(s)
        quote_count = 0
        s.to_s.
          gsub(/([{}_$&%#])/, "__LATEX_HELPER_TEMPORARY_BACKSLASH_PLACEHOLDER__\\1").
          gsub(/\\/, BACKSLASH).
          gsub(/__LATEX_HELPER_TEMPORARY_BACKSLASH_PLACEHOLDER__/, BS).
          gsub(/\^/, HAT).
          gsub(/~/, TILDE).
          gsub(/"/) do
            quote_count += 1
            quote_count.odd? ? %{"`} : %{"'}
          end
      end
      alias :l :latex_escape
    end
  end
end
