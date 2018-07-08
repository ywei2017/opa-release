# frozen_string_literal: true

require 'rspec'
require 'yaml'
require 'bosh/template/test'
require_relative 'spec_helper'

describe 'opa job' do
  let(:release_dir) { File.join(File.dirname(__FILE__), '../..') }
  let(:release) { Bosh::Template::Test::ReleaseDir.new(release_dir) }
  let(:job) { release.job('opa') }

  describe 'bpm.yml' do
    let(:template) { job.template('config/bpm.yml') }

    it 'has default values' do
      bpm_yml = YAML.safe_load(template.render({}))
      process = bpm_process(bpm_yml, 0)
      expect(process['name']).to eq('opa')
      expect(process['executable']).to eq('/var/vcap/packages/opa/opa')
    end

    it 'has default values' do
      bpm_yml = YAML.safe_load(template.render({}))
      args = bpm_process(bpm_yml, 0)['args']
      expect(args).to include('run')
      expect(args).to include('-s')
    end
  end
end
