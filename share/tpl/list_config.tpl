[% INCLUDE includes/header.tpl %]

	<h1>[% "Configuration for group [_1]" | l10n(group_name) %]</h1>
	[% FOREACH line IN config %]
	    [% IF loop.first %]
	    <table class="datatable">
		<thead>
		    <tr>
			<th>[% "Key" | l10n %]</th>
			<th>[% "Value" | l10n %]</th>
			<th>[% "del" | l10n %]</th>
		    </tr>
		</thead>
		<tbody>
	    [% END %]
		<tr class="[% loop.parity %]">
		    <td><a href="?rm=edit_config&config_id=[% line.id %]">[% line.key %]</a></td>
		    <td>[% line.value %]</td>
		    <td><a href="?rm=delete_config_ask&config_id=[% line.id %]">[% "del" | l10n %]</a></td>
		</tr>
	    [% IF loop.last %]
		</tbody>
		<tfoot></tfoot>
	    </table>
	    [% END %]
	[% END %]
	<a href="?rm=add_config&group_id=[% group_id %]">[% "Add new config item" | l10n %]</a><br />
	[% "This section lists all serice specific settings for this group." | l10n %]
	<hr />
	
[% INCLUDE includes/footer.tpl %]
