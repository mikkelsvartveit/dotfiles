// Usage: osascript -l JavaScript clipboard-png.js <out.png>
// Writes the clipboard image as PNG to <out.png> and prints "image",
// or prints "text" if the clipboard holds no image (or holds Finder files,
// whose TIFF is just the file icon).
ObjC.import("AppKit")

function run(argv) {
  const pb = $.NSPasteboard.generalPasteboard
  if (!pb.dataForType("public.file-url").isNil()) return "text"
  let data = pb.dataForType("public.png")
  if (data.isNil()) {
    const tiff = pb.dataForType("public.tiff")
    if (tiff.isNil()) return "text"
    const rep = $.NSBitmapImageRep.imageRepWithData(tiff)
    if (rep.isNil()) return "text"
    data = rep.representationUsingTypeProperties(4 /* NSBitmapImageFileTypePNG */, $.NSDictionary.dictionary)
    if (data.isNil()) return "text"
  }
  return data.writeToFileAtomically(argv[0], true) ? "image" : "text"
}
