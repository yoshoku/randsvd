require 'randsvd/version'
require 'nmatrix/lapacke'

# RandSVD is a class that performs truncated singular value decomposition
# using a randomized algorithm.
class RandSVD
  class << self
    attr_reader :seed

    # Compute the randomized singular value decompostion
    # using NMatrix::LAPACK.gesvd method.
    #
    # @param mat  [NMatrix] The m-by-n input matrix to be decomposed.
    # @param k    [Integer] The number of singular values.
    # @param t    [Integer] The number of iterations for orthogonalization.
    # @param seed [Integer] The random seed used to generate the random matrix.
    #
    # @return [Array<NMatrix>]
    #   Returns array containing the m-by-k matrix of left-singular vectors,
    #   the k-by-1 matrix containing the singular values in decreasing order,
    #   and the k-by-n transposed matrix of right-singular vectors.
    def gesvd(mat, k, t = 0, seed = nil)
      seed ||= srand
      @seed = seed
      rsvd(mat, k, t, 0)
    end

    # Compute the randomized singular value decompostion
    # using NMatrix::LAPACK.gesdd method.
    #
    # @param mat  [NMatrix] The m-by-n input matrix to be decomposed.
    # @param k    [Integer] The number of singular values.
    # @param t    [Integer] The number of iterations for orthogonalization.
    # @param seed [Integer] The random seed used to generate the random matrix.
    #
    # @return [Array<NMatrix>]
    #   Returns array containing the m-by-k matrix of left-singular vectors,
    #   the k-by-1 matrix containing the singular values in decreasing order,
    #   and the k-by-n transposed matrix of right-singular vectors.
    def gesdd(mat, k, t = 0, seed = nil)
      seed ||= srand
      @seed = seed
      rsvd(mat, k, t, 1)
    end

    private

    def rsvd(mat, k, t, svd_type)
      n = mat.shape[1]
      mat_q = make_orthonormal_mat(mat, [k + 10, n].min, t)
      mat_a = mat.dot(mat_q)
      mat_u, vec_s, mat_vt = svd_type.zero? ? mat_a.gesvd : mat_a.gesdd
      truncate_svd_mats(mat_u, vec_s, mat_q.dot(mat_vt.transpose), k)
    end

    def rand_uniform(shape)
      rng = Random.new(@seed)
      rnd_vals = Array.new(NMatrix.size(shape)) { rng.rand }
      NMatrix.new(shape, rnd_vals, dtype: :float64, stype: :dense)
    end

    def rand_normal(shape, mu = 0.0, sigma = 1.0)
      a = rand_uniform(shape)
      b = rand_uniform(shape)
      ((a.log * -2.0).sqrt * (b * 2.0 * Math::PI).sin) * sigma + mu
    end

    def make_orthonormal_mat(mat, l, t)
      m, n = mat.shape
      mat_q, = mat.transpose.dot(rand_normal([m, l])).factorize_qr
      t.times do
        mat_p, = mat.dot(mat_q[0..n - 1, 0..l - 1]).factorize_qr
        mat_q, = mat.transpose.dot(mat_p[0..m - 1, 0..l - 1]).factorize_qr
      end
      mat_q[0..n - 1, 0..l - 1]
    end

    def truncate_svd_mats(mat_u, vec_s, mat_v, k)
      m, = mat_u.shape
      n, = mat_v.shape
      [mat_u[0..m - 1, 0..k - 1],
       vec_s[0..k - 1],
       mat_v[0..n - 1, 0..k - 1].transpose]
    end
  end
end
