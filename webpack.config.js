const path = require('path')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const TerserPlugin = require("terser-webpack-plugin")

const component = `engine-${process.env.COMPONENT}`
const ports = {
    'wizard': 8080,
    'registry': 8081
}

module.exports = {
    mode: process.env.NODE_ENV === 'production' ? 'production' : 'development',

    entry: [
        `./${component}/index.js`,
        `./${component}/scss/main.scss`
    ],

    output: {
        path: path.resolve(`${__dirname}/dist/${component}/`),
        filename: '[name].[chunkhash].js',
        publicPath: '/'
    },

    module: {
        rules: [
            {
                test: /\.(scss|css)$/,
                use: [
                    MiniCssExtractPlugin.loader,
                    'css-loader',
                    'sass-loader'
                ]
            },
            {
                test: /\.html$/,
                exclude: /node_modules/,
                loader: 'file-loader',
                options: {
                    name: '[name].[ext]'
                }
            },
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader: 'elm-webpack-loader',
                options: process.env.NODE_ENV === 'production' ? {
                    verbose: true,
                    optimize: true,
                    pathToElm: 'node_modules/.bin/elm'
                } : {
                    verbose: true
                }
            },
            {
                test: /\.(svg|eot|woff|woff2|ttf)$/,
                type: 'asset/resource',
                generator: {
                    filename: '[name][ext]'
                }
            },
        ],

        noParse: /\.elm$/
    },

    optimization: {
        minimize: process.env.NODE_ENV === 'production',
        minimizer: [
            new CssMinimizerPlugin({
                minimizerOptions: {
                    preset: [
                        'default',
                        {discardComments: {removeAll: true}}
                    ]
                }
            }),
            new TerserPlugin({
                extractComments: false
            }),
            '...'
        ]
    },

    plugins: [
        new HtmlWebpackPlugin({
            template: `${component}/index.ejs`
        }),
        new MiniCssExtractPlugin({
            filename: '[name].[chunkhash].css'
        }),
        new CopyWebpackPlugin({
            patterns: [
                {from: `${component}/img`, to: 'img'},
                {from: `${component}/favicon.ico`, to: 'favicon.ico'}
            ]
        })
    ],

    devServer: {
        historyApiFallback: {disableDotRule: true},
        port: ports[component],
        static: {
            directory: __dirname
        }
    }
}
