# frozen_string_literal: true

require 'rspec'
require 'yaml'
require 'bosh/template/test'
require_relative 'spec_helper'

describe 'opa job' do
  let(:release_dir) { File.join(File.dirname(__FILE__), '../..') }
  let(:release) { Bosh::Template::Test::ReleaseDir.new(release_dir) }
  let(:job) { release.job('opa') }

  describe 'TLS files' do
    let(:tls_crt) { job.template('config/tls.crt') }
    let(:tls_key) { job.template('config/tls.key') }

    it('has certificate') do
      config = {
        'tls' => {
          'cert' => 'CERTIFICATE',
          'private_key' => 'PRIVATE_KEY'
        }
      }
      crt = tls_crt.render(config)
      expect(crt.chomp).to eq("\nCERTIFICATE\n")
    end

    it('has private key') do
      config = {
        'tls' => {
          'cert' => 'CERTIFICATE',
          'private_key' => 'PRIVATE_KEY'
        }
      }
      key = tls_key.render(config)
      expect(key.chomp).to eq("\nPRIVATE_KEY\n")
    end
  end

  describe 'bpm.yml' do
    let(:template) { job.template('config/bpm.yml') }

    it 'has expected name' do
      bpm_yml = YAML.safe_load(template.render({}))
      process = bpm_process(bpm_yml, 0)
      expect(process['name']).to eq('opa')
    end

    it 'has expected executable ' do
      bpm_yml = YAML.safe_load(template.render({}))
      process = bpm_process(bpm_yml, 0)
      expect(process['executable']).to eq('/var/vcap/packages/opa/opa')
    end

    it 'has default process args' do
      bpm_yml = YAML.safe_load(template.render({}))
      args = bpm_process(bpm_yml, 0)['args']
      expect(args).to include('run')
      expect(args).to include('--server')
      expect(args).to include('--addr=:8181')
      expect(args).to include('--authentication=off')
      expect(args).to include('--authorization=off')
      expect(args).to include('--format=pretty')
      expect(args).to include('--log-format=text')
      expect(args).to include('--log-level=info')
      expect(args).to include('--max-errors=10')
      expect(args).to include('--server-diagnostics-buffer-size=10')
    end

    it 'has configured process args' do
      config = {
        'addr' => '0.0.0.0:9021',
        'authentication' => 'token',
        'authorization' => 'token',
        'format' => 'json',
        'log-format' => 'json',
        'log-level' => 'error',
        'max-errors' => 25,
        'server-diagnostics-buffer-size' => 50
      }

      bpm_yml = YAML.safe_load(template.render(config))
      args = bpm_process(bpm_yml, 0)['args']
      expect(args).to include('--addr=0.0.0.0:9021')
      expect(args).to include('--authentication=token')
      expect(args).to include('--authorization=token')
      expect(args).to include('--format=json')
      expect(args).to include('--log-format=json')
      expect(args).to include('--log-level=error')
      expect(args).to include('--max-errors=25')
      expect(args).to include('--server-diagnostics-buffer-size=50')
    end

    it 'has configured TLS process args' do
      config = {
        'tls' => {}
      }

      bpm_yml = YAML.safe_load(template.render(config))
      args = bpm_process(bpm_yml, 0)['args']
      expect(args)
        .to include('--tls-cert-file=/var/vcap/jobs/opa/config/tls.crt')
      expect(args)
        .to include('--tls-private-key-file=/var/vcap/jobs/opa/config/tls.key')
    end
  end
end
