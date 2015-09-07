var webpack = require('webpack');

module.exports = {
  entry: './static/js/main.jsx',
  output: {
    path: './static/js',
    filename: 'bundle.js'
  },
  module: {
    loaders: [{
      test: /\.jsx?$/,
      exclude: /node_modules/,
      loader: 'jsx'
    }]
  },
  resolve: {
    modulesDirectories: ['node_modules'],
  },
  plugins: [
      new webpack.optimize.UglifyJsPlugin(),
      new webpack.ProvidePlugin({
        $: "jquery",
        jQuery: "jquery",
        "window.jQuery": "jquery"
      })
  ]
};
