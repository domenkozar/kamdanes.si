var webpack = require('webpack');

module.exports = {
  entry: './static/js/main.jsx',
  output: {
    path: './static/js',
    filename: 'main.js'
  },
  module: {
    loaders: [{
      test: /\.jsx?$/,
      exclude: /node_modules/,
      loader: 'jsx'
    }]
  },
  plugins: [
      new webpack.optimize.UglifyJsPlugin()
  ]
};
