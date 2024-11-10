return {
    {
        input = {
            "Alice has 5 apples",
        },
        expected = {
            "Bob has 5 apples",
        },
        instructions = {
            "Replace Alice with Bob",
        },
        cursor = {
            line = 1,
            col = 1,
        },
        hints = {
            "ciw to replace the word under the cursor",
        },
    },
    {
        input = {
            "Lorem ipsum dolore sit amet",
            "Bar",
            "Baz",
        },
        expected = {
            "Foo",
            "Bar",
            "Baz",
        },
        instructions = {
            "Replace the first line with 'Foo'",
        },
        hints = {
            "jk to navigate between lines",
            "cc to replace the line",
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
        },
        hints = {
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
        },
        hints = {
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
        },
        hints = {
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
        },
        hints = {
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
        },
        hints = {
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
        },
        hints = {
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
        },
        hints = {
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
        },
        hints = {
            'ca" 1',
        },
    },
    {
        input = {
            "const foo = 'foo';",
            "",
            "const test = {",
            "    2,",
            "    3,",
            "    4,",
            "};",
        },
        expected = {
            "const foo = 'foo';",
            "",
            "const test = {",
            "    1,",
            "    2,",
            "    3,",
            "    4,",
            "};",
        },
        cursor = {
            line = 7,
            col = 0,
            instructions = "You will be moved to the }",
        },
        instructions = {
            "Add a new item 1 at the beginning of the array",
        },
        hints = {
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
            'Change the array into "const test = 1;"',
        },
        hints = {
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
        },
        hints = {
            "dw deletes the next word",
            "diw deletes the word under the cursor",
            "db deletes the previous word",
            "fR can be used to navigate to the next 'R' in the line",
            "FE can be used to navigate to the previous 'E' in the line",
        },
    },
    {
        input = {
            "let a = 19999999;",
        },
        expected = {
            "let a = 20000000;",
        },
        instructions = {
            "Change 19999999 to 20000000",
        },
        hints = {
            "f1 to jump to the next '1' in the line",
            "F9 to jump to the previous '9' in the line",
            "Control-A to increment the number under the cursor",
        },
    },
    {
        input = {
            "let a = 20000000;",
        },
        expected = {
            "let a = 19999999;",
        },
        instructions = {
            "Change 20000000 to 19999999",
        },
        hints = {
            "f2 to jump to the next '2' in the line",
            "F0 to jump to the previous '0' in the line",
            "Control-X to decrement the number under the cursor",
        },
    },
    {
        input = {
            "vim.keymap.set('n', 'gf', function()",
            "    print('Go to file')",
            "end, { noremap = true })",
            "",
            "vim.keymap.set({'i', 'c'}, 'jj', '<esc>', {})",
        },
        expected = {
            "vim.keymap.set({'i', 'c'}, 'jj', '<esc>', {})",
        },
        instructions = {
            "Delete the first key binding",
        },
        hints = {
            "dip deletes the current paragraph",
            "dd deletes a line",
            "d3d deletes 3 lines",
        },
    },
    {
        input = {
            "Duplicate",
            "this",
            "paragraph",
            "",
            "Not this though",
        },
        expected = {
            "Duplicate",
            "this",
            "paragraph",
            "Duplicate",
            "this",
            "paragraph",
            "",
            "Not this though",
        },
        instructions = {
            "Duplicate the first three lines",
        },
        hints = {
            "yip copies the current paragraph",
            "P pastes the copied paragraph above the cursor",
        },
    },
    {
        input = {
            "Bob likes vim",
            "Bob likes linux",
            "Bob likes tmux",
            "",
            "Alice and Bob are friends",
        },
        expected = {
            "Alice likes vim",
            "Alice likes linux",
            "Alice likes tmux",
            "",
            "Alice and Bob are friends",
        },
        instructions = {
            "Change Bob to Alice in the first three lines",
        },
        hints = {
            ":%s/Bob/Alice/ changes the first occurrence of Bob to Alice",
            ":%s/Bob/Alice/gc changes all occurrences of Bob to Alice with confirmation",
            "V2j selects the first three lines",
            "vip selects the current paragraph",
            ":%s/Bob/Alice/g changes all occurrences of Bob to Alice",
        },
    },
    {
        input = {
            "This sentence would be better (no it wouldn't) without the part in the parentheses.",
        },
        expected = {
            "This sentence would be better without the part in the parentheses.",
        },
        instructions = {
            "Remove the parentheses and their content",
        },
        hints = {
            "dib deletes the text inside the parentheses",
            "dab deletes the parentheses and their content",
            "cib changes the text inside the parentheses",
            "cab changes the parentheses and their content",
        },
    },
    {
        input = {
            "struct Order {",
            "    name: String,",
            "    year: u32,",
            "    made_by_phone: bool,",
            "    made_by_mobile: bool,",
            "    made_by_email: bool,",
            "    item_number: u32,",
            "    count: u32,",
            "}",
        },
        expected = {
            "#[derive(Debug)]",
            "struct Order {",
            "    name: String,",
            "    year: u32,",
            "    made_by_phone: bool,",
            "    made_by_mobile: bool,",
            "    made_by_email: bool,",
            "    item_number: u32,",
            "    count: u32,",
            "}",
        },
        instructions = {
            "Add the line '#[derive(Debug)]' above the struct",
        },
        hints = {
            "gg to go to the top of the file",
            "O to open a new line above the cursor",
        },
    },
    {
        input = {
            "    et a = 1;",
        },
        expected = {
            "    let a = 1;",
        },
        instructions = {
            "Change 'et' to 'let'",
        },
        hints = {
            "No hints for this one",
        },
    },
    {
        input = {
            "    let myVar = 12345;oops",
        },
        expected = {
            "    let myVar = 12345;",
        },
        instructions = {
            "Remove the 'oops' at the end of the line",
        },
        hints = {
            "$ to move to the end of the line",
            "diw to delete the word under the cursor",
        },
    },
    {
        input = {
            "    let myVar = 12345",
        },
        expected = {
            "    let myVar = 12345;",
        },
        instructions = {
            "Add a semicolon at the end of the line",
        },
        hints = {
            "A to append at the end of the line",
        },
    },
    {
        input = {
            'let myVar = "foo";',
            'let myVar2 = "bar";',
            '// let myVar3 = "baz";',
        },
        expected = {
            '// let myVar = "foo";',
            '// let myVar2 = "bar";',
            '// let myVar3 = "baz";',
        },
        instructions = {
            "Comment out the first two lines",
        },
        hints = {
            "V to select the current line",
            "j to move down",
            "gc to comment/uncomment the selected lines",
        },
    },
    {
        input = {
            '// let myVar = "foo";',
        },
        expected = {
            'let myVar = "foo";',
        },
        instructions = {
            "Remove the comment",
        },
        hints = {
            "gcc to comment/uncomment the current line",
        },
    },
    {
        input = {
            "let a = 1;",
            "let b = 2;",
            "let c = 3;",
            "",
            "let d = 4;",
        },
        expected = {
            "// let a = 1;",
            "// let b = 2;",
            "// let c = 3;",
            "",
            "let d = 4;",
        },
        instructions = {
            "Comment out the first three lines",
        },
        hints = {
            "gcip to comment out the current paragraph",
        },
    },
    {
        input = {
            "#[derive(Debug)]",
            "pub enum Command {",
            "    Ping,",
            "    Echo(String),",
            "    Set { key: String, value: String, exp: Option<u128> },",
            "Get(String),",
            "    Info(Vec<String>),",
            "        ReplConf(Vec<String>),",
            "    Psync(String, String)",
            "},",
        },
        expected = {
            "#[derive(Debug)]",
            "pub enum Command {",
            "    Ping,",
            "    Echo(String),",
            "    Set { key: String, value: String, exp: Option<u128> },",
            "    Get(String),",
            "    Info(Vec<String>),",
            "    ReplConf(Vec<String>),",
            "    Psync(String, String)",
            "},",
        },
        instructions = {
            "Fix the indentation",
        },
        hints = {
            ">> to indent the current line",
            "<< to unindent the current line",
        },
    },
    {
        input = {
            'foo(["my string"]);',
        },
        expected = {
            'foo("my string");',
        },
        instructions = {
            "Remove the square brackets",
        },
        hints = {
            'ya" to copy the quoted text',
            "va[p to select the square brackets and the content",
            "p to paste over the selection",
        },
    },
}
