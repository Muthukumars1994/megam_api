require File.expand_path("#{File.dirname(__FILE__)}/test_helper")

class TestApps < MiniTest::Unit::TestCase

    def test_post_snapshots
        tmp_hash = {
            :account_id => "test@megam.io",
            :asm_id => "ASM535576423764486230",
            :org_id => "ORG7879663326321337888",
            :name => "pop.megambox.com",
            :status => "progress",

        }

        response = megams.post_snapshots(tmp_hash)
        assert_equal(201, response.status)
    end

    def test_get_snapshots
        response = megams.get_snapshots("ASM535576423764486230")
        assert_equal(200, response.status)
    end
=begin
    def test_list_snapshots
        response = megams.list_snapshots
        assert_equal(200, response.status)
    end
=end
end
