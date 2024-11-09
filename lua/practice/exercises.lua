return {
    {
        input = {
            "Foo",
        },
        expected = {
            "Bar",
        },
        instructions = {
            "Replace Foo with Bar",
            "ccBar",
        },
    },
    {
        input = {
            "Foo Bar Baz",
        },
        expected = {
            "Foo Baz Baz",
        },
        instructions = {
            "Replace Bar with Baz",
            "hjkl to move around, wWbB to move between words",
            "ciwBaz to replace the word under the cursor",
            "cwBaz if at the beginning of the word",
            "rz if the cursor is on the 'r' in 'Bar'",
        },
    },
    {
        input = {
            "",
            "",
            "DELETE THIS",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
        },
        expected = {
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
        },
        instructions = {
            "Delete the line with DELETE THIS",
            "#j to move to the line, if the line is below your cursor  (ex 3j)",
            "#k to move to the line above your cursor (ex 3k)",
            "dd to delete the line",
        },
    },
    {
        input = {
            "Foo",
            "bar",
            "Baz",
        },
        expected = {
            "Foo",
            "Bar",
            "Baz",
        },
        instructions = {
            "Capitalize the first letter of bar",
            "navigate with hjkl, or wWbB to move between words",
            "~ or vU to capitalize the character under the cursor",
        },
    },
    {
        input = {
            "The quick brown fox jumps Over the lazy dog",
        },
        expected = {
            "The quick brown fox jumps over the lazy dog",
        },
        instructions = {
            "Lowercase the word Over",
            "navigate with hjkl, or wWbB to move between words",
            "~ or vu to lowercase the character under the cursor",
        },
    },
    {
        input = {
            "export default function test(a: number, b: string) {",
            "    if (a > 0) {",
            "      return b;",
            "    }",
            "}",
        },
        expected = {
            "export default function test(foo: Bar) {",
            "    return foo.baz;",
            "}",
        },
        instructions = {
            "Change the function into this:",
            "export default function test(foo: Bar) {",
            "    return foo.baz;",
            "}",
            "",
            "suggestions",
            "cibfoo: Bar",
            "ciBreturn foo.baz;",
        },
    },
    {
        input = {
            "The quick brown fox jumps over the lazy dog",
            "The quick brown fox jumps over the lazy dog",
            "The quick brown fox jumrps over the lazy dog",
            "The quick brown fox jumps over the lazy dog",
            "The quick brown fox jumps over the lazy dog",
        },
        expected = {
            "The quick brown fox jumps over the lazy dog",
            "The quick brown fox jumps over the lazy dog",
            "The quick brown fox jumps over the lazy dog",
            "The quick brown fox jumps over the lazy dog",
            "The quick brown fox jumps over the lazy dog",
        },
        instructions = {
            "Fix the typo in the third line",
            "fr to jump to the next 'r' in the line",
            "Fr to jump to the previous 'r' in the line",
            "; afterwards to go to the next occurrence",
            ", to go to the previous occurrence",
            "x to remove the character under the cursor",
        },
    },
    {
        input = {
            "The quick brown",
            "fox jumps",
            "over th",
            "e lazy dog",
        },
        expected = {
            "The quick brown fox jumps over the lazy dog",
        },
        instructions = {
            "Combine the lines into a single line",
            "J to join the line below the cursor",
            "gJ to join the line without adding a space",
        },
    },
    {
        input = {
            "const test = {",
            '    one: "one",',
            '    two: "two",',
            "};",
        },
        expected = {
            "const test = {",
            "    one: 1,",
            "    two: 2,",
            "};",
        },
        instructions = {
            "Change the code into:",
            "const test = {",
            "    one: 1,",
            "    two: 2,",
            "};",
            "",
            "tip:",
            'ca" 1',
        },
    },
    {
        input = {
            "const test = {",
            "    2,",
            "    3,",
            "    4,"
            "};",
        },
        expected = {
            "const test = {",
            "    1,",
            "    2,",
            "    3,",
            "    4,",
            "};",
        },
        cursor = {
            line = 4,
            col = 0,
            instructions = "You will be moved to the }",
        },
        instructions = {
            "Add a new item 1 at the beginning of the array",
            "% to jump to the matching parenthesis",
            "o to open a new line below the cursor",
        },
    },
    {
        input = {
            "const test = [",
            '    "foo",',
            '    "bar",',
            '    "baz",',
            "];",
        },
        expected = {
            "const test = 1;",
        },
        instructions = {
            'Change the array into ["test"]',
            "ca[1;",
        },
    },
    {
        input = {
            "keep keep keep REMOVE keep keep",
        },
        expected = {
            "keep keep keep keep keep",
        },
        instructions = {
            "Remove the word 'REMOVE'",
            "",
            "tips:",
            "dw deletes the next word",
            "diw deletes the word under the cursor",
            "db deletes the previous word",
            "fR can be used to navigate to the next 'R' in the line",
            "FE can be used to navigate to the previous 'E' in the line",
        },
    },
}
