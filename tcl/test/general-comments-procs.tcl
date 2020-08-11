ad_library {
    Test general-comments API
}

aa_register_case \
    -cats {api smoke} \
    -procs {
        general_comments_create_link
        general_comments_package_url
    } \
    general_comments_create_link {
        Test general_comments_create_link
    } {
        set gc_url [general_comments_package_url]

        set vars {
            object_name
            link_text
            context_id
            category
            link_attributes
            object_id
            return_url
        }
        foreach var $vars {
            set $var [ad_generate_random_string]
        }

        set url [general_comments_create_link \
                     -object_name $object_name \
                     -link_text $link_text \
                     -context_id $context_id \
                     -category $category \
                     -link_attributes $link_attributes \
                     $object_id $return_url]

        aa_true "Generated link is HTML" [ad_looks_like_html_p $url]

        foreach var $vars {
            aa_true "Link contains suplied argument '$var'" {[string first [set $var] $url] >= 0}
        }

        if {$gc_url ne ""} {
            aa_true "Link contains general-comments package URL '$gc_url'" {[string first $gc_url $url] >= 0}
        }
    }
