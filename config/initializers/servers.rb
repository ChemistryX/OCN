
Rails.configuration.tap do |config|
    config.servers = {
        cloudflare: {
            api_key: '...',
            email: '...'
        },

        dns: {
            zone: '...',
            enabled_prefix: 'kiwi',
            disabled_prefix: 'lime',
            ttl: 120.seconds,
            resolve_timeout: 3.seconds,
        },

        # Minimum bungees online at any given time
        datacenters: {
            'KR' => { minimum_bungees: 0 }
        }
    }
end
