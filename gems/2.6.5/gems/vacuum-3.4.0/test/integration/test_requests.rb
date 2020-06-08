# frozen_string_literal: true

require 'integration_helper'

module Vacuum
  class TestRequests < IntegrationTest
    def test_get_browse_nodes
      requests.each do |request|
        response = request.get_browse_nodes(browse_node_ids: ['3045'])
        assert_equal 200, response.status
      end
    end

    def test_get_items
      requests.each do |request|
        response = request.get_items(item_ids: ['B07212L4G2'])
        assert_equal 200, response.status
      end
    end

    def test_get_items_with_all_resources
      requests.each do |request|
        response = request.get_items(item_ids: 'B07212L4G2',
                                     resources: Resource.all)
        assert_equal 200, response.status
        item = response.dig('ItemsResult', 'Items').first
        assert item.key?('BrowseNodeInfo')
      end
    end

    def test_get_variations
      requests.each do |request|
        response = request.get_variations(asin: 'B07212L4G2')
        assert_equal 200, response.status
      end
    end

    def test_search_items
      requests.each do |request|
        response = request.search_items(keywords: 'Harry Potter')
        assert_equal 200, response.status
      end
    end

    def test_persistent
      request = requests.sample
      refute request.client.persistent?
      request.persistent
      assert request.client.persistent?
    end

    def test_logging
      require 'logger'
      logdev = StringIO.new
      logger = Logger.new(logdev)
      request = requests.sample
      request.use(logging: { logger: logger })
      request.search_items(keywords: 'Harry Potter')
      refute_empty logdev.string
    end
  end
end
