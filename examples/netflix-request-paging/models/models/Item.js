(function ( models ) {
    models.Item = Backbone.Model.extend({
        parse: function(json){

            if( json.Runtime ){
                json.RuntimeMinutes = parseInt(json.Runtime / 60, 10) + ' mins';
            }
            else {
                json.Runtime = "";
                json.RuntimeMinutes = "";
            }

            return json;

        }
    });
})( app.models );