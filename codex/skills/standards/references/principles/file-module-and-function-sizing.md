# File, module, and function sizing

- Choose a file boundary around one cohesive concept, ownership area, or change reason.
- Split when unrelated responsibilities, review noise, navigation cost, or independent lifecycle make the boundary clearer.
- Keep a larger file when splitting would create shallow wrappers, scatter one invariant, or force readers across many files for one operation.
- Choose a function boundary around a meaningful operation with a clear input, output, and failure story.
- Split when control flow, state, dependencies, or failure paths become hard to read, test, debug, or reuse.
- Keep a longer function when its steps form one coherent algorithm and extraction would hide necessary relationships.
- Treat line counts as investigation signals, never universal acceptance criteria.
- Google recommends small focused functions, sets no hard length limit, and suggests reconsidering a function at about 40 lines when splitting would preserve structure.
- Ousterhout notes that long methods can be valid when their pieces are relatively independent and that module depth matters more than making every class tiny.
- Avoid one-line wrappers, pass-through methods, and files that exist only to satisfy a number.
- A short function can still be complex if it invokes many abstractions, branches on hidden state, or needs non-local knowledge.
