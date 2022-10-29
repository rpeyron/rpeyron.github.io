# https://github.com/abelards/jekyll-array-intersect/blob/master/array_intersection.rb

# ArrayIntersectionFilter
# these three lines will help you find common tags/topics/categories.
# use `intersection` to get a boolean, `intersect` to get an array
# example: `{{ assign related = a | intersection: b }}`

module Jekyll
    module ArrayIntersectionFilter

      def intersect(var,args)
        a = var.is_a?(Array) ? var : var.to_s.split(',').map(&:strip)
        b = args.is_a?(Array) ? args : args.to_s.split(',').map(&:strip)
        res = (a & b)
      end
  
      def intersection(var, args)
        intersect(var,args).size != 0
      end
    end
  end
  
  Liquid::Template.register_filter(Jekyll::ArrayIntersectionFilter)