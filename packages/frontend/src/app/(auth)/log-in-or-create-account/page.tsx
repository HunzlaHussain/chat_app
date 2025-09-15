"use client";

import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { motion } from "framer-motion";




export default function LogInOrCreateAccount() {

  return (
    <>
      <motion.h1 className="sm:text-center text-left sm:text-2xl text-lg ml-4 sm:ml-0 font-bold mt-10" initial={{ opacity:0}} animate={{ opacity:1}} transition={{ duration:0.5}}>
        Chit Chat
      </motion.h1>
      <motion.p className="mt-4 text-center font-medium" initial={{ opacity:0}} animate={{ opacity:1}} transition={{ duration:0.5}}>
        Chat freely, connect instantly.
      </motion.p>

      <Card className="w-full max-w-sm mx-auto mt-10">
        <CardHeader>
          <CardTitle>Login to your account</CardTitle>
          <CardDescription>
            Enter your email below to login to your account
          </CardDescription>
        </CardHeader>
        <CardContent className="align-center justify-center">
          <form>
            <div className="flex flex-col gap-6">
              <div className="grid gap-2">
                <Label htmlFor="email">Email</Label>
                <Input
                  id="email"
                  type="email"
                  placeholder="m@example.com"
                  required
                />
              </div>
              <div className="grid gap-2">
                <div className="flex items-center">
                  <Label htmlFor="password" >Password</Label>
                  <a
                    href="#"
                    className="ml-auto inline-block text-sm underline-offset-4 hover:underline"
                  >
                    Forgot your password?
                  </a>
                </div>
                <Input id="password" placeholder="********"  type="password" required />
              </div>
            </div>
          </form>
        </CardContent>
        <CardFooter className="flex-col gap-2">
          <Button type="submit" className="w-full">
            Login
          </Button>
          <Button variant="outline" className="w-full flex items-center justify-center gap-2">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" className="w-6 h-6">
  <path fill="#4285F4" d="M44.5 20H24v8.5h11.9c-1.2 3.9-4.9 6.7-9.9 6.7-5.9 0-10.6-4.8-10.6-10.6S20.1 13.9 26 13.9c2.6 0 5 0.9 6.8 2.7l5.9-5.9C35.4 7.3 30.9 5.5 26 5.5 15.7 5.5 7.5 13.7 7.5 24S15.7 42.5 26 42.5c11.3 0 18.5-7.9 18.5-18.9 0-1.3-.1-2.2-.3-3.6z"/>
  <path fill="#34A853" d="M6.3 14.7l6.9 5.1C14.9 16.1 19.9 13 26 13c2.6 0 5 0.9 6.8 2.7l5.9-5.9C35.4 7.3 30.9 5.5 26 5.5 18 5.5 11 9.7 6.3 14.7z"/>
  <path fill="#FBBC05" d="M26 42.5c4.9 0 9.4-1.7 12.8-4.7l-6-5.1c-1.8 1.5-4.2 2.4-6.8 2.4-5.1 0-9.5-3.3-11.1-7.9l-6.8 5.3C11 38.3 18 42.5 26 42.5z"/>
  <path fill="#EA4335" d="M44.5 20H24v8.5h11.9c-.6 1.9-1.8 3.7-3.5 4.9l6 5.1c2.5-2.3 4.1-5.9 4.1-10.5 0-.7-.1-1.3-.2-2z"/>
</svg>
            Login with Google
          </Button>

          <Button variant="outline" className="w-full flex items-center justify-center gap-2">
          <svg role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><title>Facebook</title><path d="M9.101 23.691v-7.98H6.627v-3.667h2.474v-1.58c0-4.085 1.848-5.978 5.858-5.978.401 0 .955.042 1.468.103a8.68 8.68 0 0 1 1.141.195v3.325a8.623 8.623 0 0 0-.653-.036 26.805 26.805 0 0 0-.733-.009c-.707 0-1.259.096-1.675.309a1.686 1.686 0 0 0-.679.622c-.258.42-.374.995-.374 1.752v1.297h3.919l-.386 2.103-.287 1.564h-3.246v8.245C19.396 23.238 24 18.179 24 12.044c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.628 3.874 10.35 9.101 11.647Z"/></svg>
            Login with Facebook
          </Button>
        </CardFooter>
      </Card>
    </>
  );
}
