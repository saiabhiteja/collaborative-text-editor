module.exports = {
    test: /\.tsx?(\.erb)?$/,
    use: [
      {
        loader: 'ts-loader',
        options: {
          transpileOnly: true
        }
      }
    ]
  }