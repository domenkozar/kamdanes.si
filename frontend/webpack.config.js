var path = require("path"),
    webpack = require('webpack');

module.exports = {
  entry: {
    app: [
      './index.js'
    ]
  },

  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: 'app.js',
  },

  module: {
    loaders: [
      {
        test: /\.(css|scss)$/,
        loaders: [
          'style-loader',
          'css-loader',
        ]
      },
      {
        test:    /\.html$/,
        exclude: /node_modules/,
        loader:  'file?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack',
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&minetype=application/font-woff',
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader',
      },
    ],

    noParse: /\.elm$/,
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
  ],
  devServer: {
    inline: true,
    stats: { colors: true },
  },


};
