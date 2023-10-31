import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const nextUrl = request.nextUrl;
  const url = new URL(request.url);
  if (url.hash) {
    return NextResponse.rewrite(new URL('/', request.url));
  }
}
