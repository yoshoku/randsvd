require 'spec_helper'

RSpec.describe RandSVD do
  let(:m) { 1000 }
  let(:n) { 50 }
  let(:k) { 10 }
  let(:mat) { NMatrix.rand([m, k]).dot(NMatrix.rand([k, n])) }
  let(:err) { 1.0e-5 }
  let(:seed) { 1000 }

  it 'has small reconstruction error.' do
    u, s, vt = described_class.gesvd(mat, k)
    mat_svd = u.dot(NMatrix.diag(s).dot(vt))
    u, s, vt = described_class.gesdd(mat, k)
    mat_sdd = u.dot(NMatrix.diag(s).dot(vt))
    expect(mat_svd).to be_within(err).of(mat)
    expect(mat_sdd).to be_within(err).of(mat)
  end

  it 'has small error about singular values and vectors.' do
    th_u, th_s, th_vt = described_class.gesvd(mat, k)
    u, s, vt = mat.gesvd
    tr_u = u[0..m - 1, 0..k - 1]
    tr_s = s[0..k - 1]
    tr_vt = vt[0..k - 1, 0..n - 1]
    expect(th_u).to be_within(err).of(tr_u)
    expect(th_s).to be_within(err).of(tr_s)
    expect(th_vt).to be_within(err).of(tr_vt)
  end

  it 'obtains the same results by fixing the random seed.' do
    u_a, s_a, vt_a = described_class.gesvd(mat, k, 0, seed)
    u_b, s_b, vt_b = described_class.gesvd(mat, k, 0, seed)
    expect(described_class.seed).to be(seed)
    expect(u_a).to eq(u_b)
    expect(s_a).to eq(s_b)
    expect(vt_a).to eq(vt_b)
  end
end
