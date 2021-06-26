# RandSVD

[![Build Status](https://github.com/yoshoku/randsvd/actions/workflows/build.yml/badge.svg)](https://github.com/yoshoku/randsvd/actions/workflows/build.yml)
[![Gem Version](https://badge.fury.io/rb/randsvd.svg)](https://badge.fury.io/rb/randsvd)

RandSVD is a class that performs truncated singular value decomposition using a randomized algorithm.
To implement, I referred to the following papers:

- P.-G. Martinsson, A. Szlam, M. Tygert, "Normalized power iterations for the computation of SVD," Proc. of NIPS Workshop on Low-Rank Methods for Large-Scale Machine Learning, 2011.
- P.-G. Martinsson, V. Rokhlin, M. Tygert, "A randomized algorithm for the approximation of matrices," Tech. Rep., 1361, Yale University Department of Computer Science, 2006.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'randsvd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install randsvd

## Usage

```ruby
require 'randsvd'

# Initialize some variables.
input_matrix = NMatrix.rand([1000, 100])
nb_singular_values = 10

# Perform the randomized singular value decomposition.
u, s, vt = RandSVD.gesvd(input_matrix, nb_singular_values)

# Reconstruct the matrix with the singular values and vectors.
reconstructed_matrix = u.dot(NMatrix.diag(s).dot(vt))
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/randsvd. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
