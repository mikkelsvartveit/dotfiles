// Usage: osascript -l JavaScript clipboard-png.js <out.png>
// Writes the clipboard image as PNG to <out.png> and prints "image",
// or prints "text" if the clipboard holds no image.
//
// A copied file (Finder, Raycast clipboard history, ...) counts as an image
// only if the file itself is one; the TIFF Finder puts next to it is just the
// file icon.
ObjC.import("AppKit")

const IMAGE_EXT = ["png", "jpg", "jpeg", "gif", "tif", "tiff", "heic", "heif", "webp", "bmp"]
const PNG = 4 // NSBitmapImageFileTypePNG

function toPng(data) {
  if (data.isNil()) return data
  const rep = $.NSBitmapImageRep.imageRepWithData(data)
  if (rep.isNil()) return rep
  return rep.representationUsingTypeProperties(PNG, $.NSDictionary.dictionary)
}

function clipboardImage(pb) {
  const urlData = pb.dataForType("public.file-url")
  if (!urlData.isNil()) {
    // Copied image file (Finder): use the file contents.
    const url = $.NSURL.URLWithString($.NSString.alloc.initWithDataEncoding(urlData, $.NSUTF8StringEncoding))
    const path = !url.isNil() && url.isFileURL ? url.path.js : ""
    const ext = path.split(".").pop().toLowerCase()
    if (path && IMAGE_EXT.includes(ext)) {
      const file = $.NSData.dataWithContentsOfFile(path)
      return ext === "png" ? file : toPng(file)
    }
  }
  // Raycast clipboard history puts PNG data next to a file URL, so check PNG
  // before treating a file URL as "not an image".
  const png = pb.dataForType("public.png")
  if (!png.isNil()) return png
  if (!urlData.isNil()) return $() // other copied file: its TIFF is just the file icon
  for (const type of ["public.tiff", "public.jpeg", "public.heic", "com.compuserve.gif", "org.webmproject.webp"]) {
    const data = pb.dataForType(type)
    if (!data.isNil()) return toPng(data)
  }
  return $()
}

function run(argv) {
  const data = clipboardImage($.NSPasteboard.generalPasteboard)
  if (data.isNil()) return "text"
  return data.writeToFileAtomically(argv[0], true) ? "image" : "text"
}
