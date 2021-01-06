package main;

import "bindgen"

main :: proc() {
	options : bindgen.GeneratorOptions;
    bindgen.generate(
        packageName = "wren",
        foreignLibrary = "./libwren.a",
        outputFile = "wren.odin",
        headerFiles = []string{"./wren.h"},
        options = options,
    );
}
