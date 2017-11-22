<?xml version="1.0"?>
<queryset>

  <partialquery name="status_approved">
    <querytext>

      i.live_revision is not null

    </querytext>
  </partialquery>

  <partialquery name="status_unapproved">
    <querytext>

      i.live_revision is null

    </querytext>
  </partialquery>

  <partialquery name="modified_show_all">
    <querytext>

      1 = 1

    </querytext>
  </partialquery>

  <partialquery name="modified_last_24hours">
    <querytext>

      creation_date > current_timestamp - interval '1' day

    </querytext>
  </partialquery>

  <partialquery name="modified_last_week">
    <querytext>

      creation_date > current_timestamp - interval '7' day

    </querytext>
  </partialquery>

  <partialquery name="modified_last_month">
    <querytext>

      creation_date > current_timestamp - interval '30' day

    </querytext>
  </partialquery>

</queryset>
